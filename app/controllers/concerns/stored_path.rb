module StoredPath
  extend ActiveSupport::Concern

  included do
    helper_method :stored_cpath
  end

  def stored_cpath
    @stored_path ||= session.delete(:stored_path) || root_path
  end

  def store_request_path!
    session[:stored_path] = request.fullpath
  end
end
