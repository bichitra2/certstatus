import io
from ruamel.yaml import YAML
from yamllint import linter, config

# Function to format YAML (correct indentation and remove extra spaces)
def format_yaml(yaml_string):
    yaml = YAML()
    yaml.preserve_quotes = True  # Keep quotes as they are in the original YAML
    yaml.indent(mapping=2, sequence=4, offset=2)  # Set indentation preferences

    try:
        # Load YAML string into StringIO buffer
        yaml_buffer = io.StringIO(yaml_string)
        data = yaml.load(yaml_buffer)  # Load YAML content from buffer
    except Exception as e:
        raise ValueError(f"Syntax error in YAML: {e}")

    # Convert YAML back to string with proper formatting
    formatted_yaml = io.StringIO()
    yaml.dump(data, formatted_yaml)

    # Remove trailing whitespaces from each line
    formatted_yaml.seek(0)
    formatted_content = "\n".join([line.rstrip() for line in formatted_yaml.getvalue().splitlines()])

    return formatted_content

# Function to check for duplicate keys
def check_duplicate_keys(yaml_string):
    yaml = YAML()
    yaml.allow_duplicate_keys = False  # Disallow duplicate keys
    try:
        yaml_buffer = io.StringIO(yaml_string)
        yaml.load(yaml_buffer)
        return "No duplicate keys found."
    except Exception as e:
        return f"Duplicate key error: {e}"

# Function to run yamllint for advanced checks (length, trailing space, indentation)
def run_yamllint(yaml_string):
    yamllint_config = """
    extends: default
    rules:
      line-length:
        max: 120  # Maximum line length
        allow-non-breakable-inline-mappings: true
      trailing-spaces: enable  # Ensure no trailing spaces
      indentation:
        spaces: 2  # Enforce 2-space indentation
    """
    
    config_obj = config.YamlLintConfig(yamllint_config)
    lint_issues = list(linter.run(yaml_string, config_obj))

    # Capture linting issues
    issues = [str(issue) for issue in lint_issues]

    return issues if issues else ["No linting issues found."]

# Main function to validate and format YAML from string buffer
def check_and_format_yaml(yaml_content):
    # Step 1: Check for syntax and format the YAML content
    try:
        formatted_yaml = format_yaml(yaml_content)
        print("YAML formatted successfully.")
    except Exception as e:
        return f"Error while formatting YAML: {e}"

    # Step 2: Check for duplicate keys
    duplicate_check_result = check_duplicate_keys(yaml_content)
    print(duplicate_check_result)

    # Step 3: Run yamllint for linting issues
    linting_issues = run_yamllint(yaml_content)
    print("\nLinting issues:")
    for issue in linting_issues:
        print(issue)

    # Return the formatted YAML
    return formatted_yaml

# Example usage with YAML content from a string
yaml_string = """
example:
  key1: value1
  key2: value2
  key1: duplicate_value
list_example:
  - item1
  - item2
"""

result = check_and_format_yaml(yaml_string)
print("\nFormatted YAML Output:")
print(result)
