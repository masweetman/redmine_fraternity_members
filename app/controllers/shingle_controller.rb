include Redmine::Export::PDF::ShinglePdfHelper

class ShingleController < ApplicationController
  #unloadable
  before_filter :authorize_global, :only => [:mark_as_shipped, :mark_all_as_shipped]

  def index
    @project = Project.find(6)
    @shingles = Issue.where("tracker_id = 30 AND status_id <> 9")
  end

  def mark_all_as_shipped
    @project = Project.find(6)
    shingles = Issue.where("tracker_id = 30 AND status_id <> 9")
    shingles.each do |shingle|
      shingle.status_id = 9
      shingle.save
    end
    redirect_to controller: "shingle", action: "index"
    flash[:notice] = l(:notice_successful_update)
  end

  def mark_as_shipped
    @project = Project.find(6)
    shingle = Issue.find(params[:shingle])
    shingle.status_id = 9
    shingle.save
    redirect_to controller: "shingle", action: "index"
    flash[:notice] = l(:notice_successful_update)
  end

  def invoices_export_pdf
    send_data(shingles_invoices_pdf, :type => 'application/pdf',
      :filename => 'Unshipped_Shingles_Invoices.pdf')
  end

  def shingle_export_pdf
    shingle = Issue.find(params[:id])
    send_data(shingle_to_pdf(shingle), :type => 'application/pdf',
      :filename => shingle.custom_field_value(134).to_s + '_' + shingle.custom_field_value(136).to_s.gsub('/', '-') + '_shingles.pdf')
  end

  def shingles_export_pdf
    send_data(shingles_to_pdf, :type => 'application/pdf',
      :filename => 'Unshipped_Shingles.pdf')
  end

  def new_shingle_export_pdf
    shingle = Issue.find(params[:id])
    send_data(new_shingle_to_pdf(shingle, params), :type => 'application/pdf',
      :filename => shingle.custom_field_value(134).to_s + '_' + shingle.custom_field_value(136).to_s.gsub('/', '-') + '_shingles.pdf')
  end

  def new_shingles_export_pdf
    send_data(new_shingles_to_pdf(params), :type => 'application/pdf',
      :filename => 'Unshipped_Shingles.pdf')
  end

end
