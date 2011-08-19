APP_CONFIG = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
INDEX_PROBLEMS = YAML.load_file("#{Rails.root}/config/problems.yml")