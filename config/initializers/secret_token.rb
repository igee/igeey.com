# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Igee::Application.config.secret_token = APP_CONFIG['secret_token'] || 'f229c299eb2c7b64b6e65ef6df256a42138aec2c7f2bbe8fba6a10435944c5c32f287d173a4f208a4085d866f27f9241c83e076872c62242b594910e37837883'
