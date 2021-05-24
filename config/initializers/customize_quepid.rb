# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# This file checks for various customization options passed in as environment
# variables.

bool = ActiveRecord::Type::Boolean.new

# == Quepid Default Scorer
# New users to Quepid need to have a recommended scorer to use, which they can then
# override to their own preferred scorer, either one of the defaults shipped with Quepid
# or a custom scorer.
#
Rails.application.config.quepid_default_scorer = ENV.fetch('QUEPID_DEFAULT_SCORER', 'AP@10')

# == Email Marketing Permission
# To comply with GDPR, and be a good citizen, the hosted version of Quepid asks
# if they are willing to receive Quepid related updates via email.  This feature
# isn't useful to private installs, so this controls the display.
#
Rails.application.config.email_marketing_mode = bool.deserialize(ENV.fetch('EMAIL_MARKETING_MODE', false))

# == Cookies Policy URL
# To comply with GDPR, and be a good citizen, the hosted version of Quepid asks
# about cookies and provides a link to the cookies policy. This feature
# isn't useful to private installs, so this controls the display.
#
Rails.application.config.cookies_url = ENV.fetch('COOKIES_URL', nil)

# == Privacy Policy URL
# To comply with GDPR, and be a good citizen, the hosted version of Quepid links
# to a privacy policy. This feature isn't useful to private installs, so this
# controls the display.
#
Rails.application.config.privacy_url = ENV.fetch('PRIVACY_URL', nil)

# == Hosted App.quepid.com T&C's
# Users of the free hosted app.quepid.com are asked to agree to certain terms &
# conditions. This feature isn't useful to private installs, so this
# controls the display.
#
Rails.application.config.terms_and_conditions_url = ENV.fetch('TC_URL', nil)

# == Enable signup
# This parameter controls whether or not signing up via the UI is enabled.
Rails.application.config.signup_enabled = bool.deserialize(ENV.fetch('SIGNUP_ENABLED', true))

# == Communal Scorers Only
# Users can normally create custom scorers which run embedded javascript, this is a potential
# security flaw as malicious javascript could be entered. This setting restricts users to
# communal scorers only, which are controlled by admins.
#
Rails.application.config.communal_scorers_only = bool.deserialize(ENV.fetch('COMMUNAL_SCORERS_ONLY', false))

# == What Email Provider to Use
# You can send emails to users using either the Postmark Saas service by setting this to POSTMARK, or
# you can send using traditional SMTP server by setting this to SMTP.  Leave it blank and there is
# no email provider.
Rails.application.config.email_provider = ENV.fetch('EMAIL_PROVIDER', '')

# == Email Address of the Sender of Emails
# When Quepid sends emails to users, what is the email address of the sender?
Rails.application.config.email_sender = ENV.fetch('EMAIL_SENDER', '')

# == Query List Sortable
# See https://github.com/o19s/quepid/issues/272 for a bug in expand/collapse that some setups experience.
# This lets you disable the sorting if you experience the bug.
#
Rails.application.config.query_list_sortable = bool.deserialize(ENV.fetch('QUERY_LIST_SORTABLE', true))

# = OAuth Settings =
# ==
Rails.application.config.google_client_id = ENV.fetch('GOOGLE_CLIENT_ID', '')
Rails.application.config.google_client_secret = ENV.fetch('GOOGLE_CLIENT_SECRET', '')

Rails.application.config.keycloak_realm = ENV.fetch('KEYCLOAK_REALM', '')
Rails.application.config.keycloak_site = ENV.fetch('KEYCLOAK_SITE', '')
