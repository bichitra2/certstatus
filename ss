#!/usr/bin/env python3

import tkinter as tk
from tkinter import messagebox, filedialog

def generate_script():
    service_name = entry_service.get().strip()
    backend_url = entry_backend.get().strip()
    cert_host = entry_cert.get().strip()

    if not service_name or not backend_url or not cert_host:
        messagebox.showerror("Error", "Please fill in all fields!")
        return

    # Ask where to save the combined script
    file_path = filedialog.asksaveasfilename(
        defaultextension=".sh",
        filetypes=[("Shell Script", "*.sh")],
        title="Save Combined Script As"
    )

    if not file_path:
        return

    try:
        # Construct the combined script
        script_content = f"""#!/bin/bash

# SERVER STATUS
echo "=== SERVER STATUS ({service_name}) ==="
systemctl status {service_name}
echo

# BACKEND CONNECTION
echo "=== BACKEND CONNECTION ({backend_url}) ==="
curl -I {backend_url}
echo

# CERTIFICATE VALIDITY
echo "=== CERTIFICATE VALIDITY ({cert_host}) ==="
echo | openssl s_client -connect {cert_host}:443 2>/dev/null | openssl x509 -noout -enddate
echo
"""
        # Write the script to the file
        with open(file_path, "w") as f:
            f.write(script_content)

        # Make script executable
        import os
        os.chmod(file_path, 0o755)

        messagebox.showinfo("Success", f"Combined script created: {file_path}")

    except Exception as e:
        messagebox.showerror("Error", f"Failed to create script:\n{str(e)}")


# GUI
root = tk.Tk()
root.title("Linux Script Generator")

tk.Label(root, text="Linux Service Name:").grid(row=0, column=0, sticky="e", padx=5, pady=5)
tk.Label(root, text="Backend URL:").grid(row=1, column=0, sticky="e", padx=5, pady=5)
tk.Label(root, text="Certificate Host:").grid(row=2, column=0, sticky="e", padx=5, pady=5)

entry_service = tk.Entry(root, width=40)
entry_service.grid(row=0, column=1, padx=5, pady=5)
entry_backend = tk.Entry(root, width=40)
entry_backend.grid(row=1, column=1, padx=5, pady=5)
entry_cert = tk.Entry(root, width=40)
entry_cert.grid(row=2, column=1, padx=5, pady=5)

tk.Button(root, text="Generate Combined Script", command=generate_script, bg="green", fg="white").grid(
    row=3, column=0, columnspan=2, pady=10
)

root.mainloop()
