import os
import io
from ruamel.yaml import YAML
from yamllint import linter, config

# Function to load and validate YAML without using yaml.dump
def load_yaml_from_string(yaml_string):
    yaml = YAML()
    yaml.preserve_quotes = True
    yaml.indent(mapping=2, sequence=4, offset=2)  # Set indentation rules
    return yaml.load(yaml_string)

# Function to validate YAML syntax
def validate_yaml(yaml_string):
    try:
        load_yaml_from_string(yaml_string)
        return "YAML syntax is valid."
    except Exception as e:
        return f"YAML syntax error: {e}"

# Function to check for duplicate keys
def check_duplicate_keys(yaml_string):
    yaml = YAML()
    yaml.allow_duplicate_keys = False  # Disallow duplicate keys
    try:
        load_yaml_from_string(yaml_string)
        return "No duplicate keys found."
    except Exception as e:
        return f"Duplicate key error: {e}"

# Function to run yamllint on the YAML string without length checks
def run_yamllint(yaml_string):
    yamllint_config = """
    extends: default
    rules:
      trailing-spaces: enable  # Ensure no trailing spaces
      indentation:
        spaces: 2  # Enforce 2-space indentation
    """
    
    config_obj = config.YamlLintConfig(yamllint_config)
    lint_issues = list(linter.run(yaml_string, config_obj))

    # Capture linting issues
    issues = [str(issue) for issue in lint_issues]

    return issues if issues else ["No linting issues found."]

# Main function to check and validate YAML files
def check_and_validate_yaml(file_path):
    if not os.path.exists(file_path):
        return f"File '{file_path}' does not exist."

    with open(file_path, 'r') as file:
        yaml_content = file.read()

    # Step 1: Validate YAML syntax
    syntax_validation = validate_yaml(yaml_content)
    print(syntax_validation)

    # Step 2: Check for duplicate keys
    duplicate_check_result = check_duplicate_keys(yaml_content)
    print(duplicate_check_result)

    # Step 3: Run yamllint for indentation and trailing space checks
    linting_issues = run_yamllint(yaml_content)
    print("\nLinting issues:")
    for issue in linting_issues:
        print(issue)

# Example usage
if __name__ == "__main__":
    file_path = 'example.yaml'  # Replace with your YAML file path
    check_and_validate_yaml(file_path)
