
Dir.entries("#{Rails.root}/public/jasperreports").each do |lib|
  require "#{Rails.root}/public/jasperreports/#{lib}" if lib =~ /\.jar$/
end
#require_dependency "#{Rails.root}/public/jasperreports/jasperreports-6.3.0.jar"
#require_dependency "#{Rails.root}/public/jasperreports/jasperreports-fonts-6.3.0.jar"
#require_dependency "#{Rails.root}/public/jasperreports/jasperreports-javaflow-6.3.0.jar"
require 'java'
java_import Java::net::sf::jasperreports::engine::JasperFillManager
java_import Java::net::sf::jasperreports::engine::JasperExportManager
java_import Java::net.sf.jasperreports.engine.JRResultSetDataSource

class JasperReport
  DIR = "#{Rails.root}/reports"

  def initialize(report, query, params = nil)
    @model = report
    @report_params = params
    @conn = ActiveRecord::Base.connection.jdbc_connection
    @query = query
  end

  def to_pdf
    stmt = @conn.create_statement
    @result = JRResultSetDataSource.new(stmt.execute_query(@query))
    report_source = "#{DIR}/#{@model}.jasper"
    raise ArgumentError, "#@model does not exist." unless File.exist?(report_source)
    params = {}
    params.merge!(@report_params) if @report_params.present?
    fill = JasperFillManager.fill_report(report_source, params, @result)
    pdf = JasperExportManager.export_report_to_pdf(fill)
    return String.from_java_bytes(pdf)
  end
end
