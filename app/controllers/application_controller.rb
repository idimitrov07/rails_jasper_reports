require_dependency "#{Rails.root}/lib/jasper_report"

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def respond_to_report(name, query, filename, download = false, report_params = nil)
    @report = JasperReport.new(name, query, report_params)
    disposition = (download.nil? || download == false) ? 'inline' : 'attachment'
    send_data @report.to_pdf, :filename => filename, :type => :pdf, :disposition => disposition
  end
end
