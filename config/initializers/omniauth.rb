Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, Figaro.env.github_key, Figaro.env.github_secret
end