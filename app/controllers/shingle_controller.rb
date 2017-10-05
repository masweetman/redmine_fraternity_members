include Redmine::Export::PDF::ShinglePdfHelper

class ShingleController < ApplicationController
  #unloadable
  before_filter :authorize_global, :only => [:index, :mark_as_shipped, :mark_all_as_shipped, :new_shingle_export_pdf, :new_shingles_export_pdf, :signature_upload]

  def index
    if User.current.member_of? Project.find(6)
      @project = Project.find(6)
      @shingles = Issue.where("tracker_id = 30 AND status_id <> 9")
      @national = true
    else
      @project = Project.find(params[:id])
      @shingles = Issue.where("tracker_id = 30 AND status_id <> 9 AND project_id = ?", @project.id)
      @national = false
    end

    @setting = Setting.plugin_redmine_fraternity_members
    if @setting['shingle_settings'].nil?
      @setting['shingle_settings'] = {}
      @setting['shingle_settings']['include_seal'] = 1
      @setting['shingle_settings']['include_signature'] = 1
      @setting['shingle_settings']['safe_font'] = 0
      @setting['shingle_settings']['signature_size'] = 12
      @setting['shingle_settings']['signature_x'] = 115
      @setting['shingle_settings']['signature_y'] = 228
      Setting.send "plugin_redmine_fraternity_members=", @setting
    end
    if request.post?
      @setting = Setting.plugin_redmine_fraternity_members
      @setting['shingle_settings']['include_seal'] = params["include_seal"]
      @setting['shingle_settings']['include_signature'] = params["include_signature"]
      @setting['shingle_settings']['safe_font'] = params["safe_font"]
      @setting['shingle_settings']['signature_size'] = params["signature_size"]
      @setting['shingle_settings']['signature_x'] = params["signature_x"]
      @setting['shingle_settings']['signature_y'] = params["signature_y"]
      Setting.send "plugin_redmine_fraternity_members=", @setting
      flash[:notice] = l(:notice_successful_update)
      redirect_to controller: 'shingle', action: 'index'
    end
  end

  def signature_upload
    uploaded_io = params[:signature]
    File.open(Rails.root.join('files', 'shingles', 'signature.png'), 'wb') do |file|
      file.write(uploaded_io.read)
      flash[:notice] = 'Signature uploaded successfully.'
    end
    redirect_to controller: 'shingle', action: 'index'
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
    send_data(new_shingle_to_pdf(shingle, "0"), :type => 'application/pdf',
      :filename => shingle.custom_field_value(134).to_s + '_' + shingle.custom_field_value(136).to_s.gsub('/', '-') + '_shingles.pdf')
  end

  def new_shingles_export_pdf
    send_data(new_shingles_to_pdf, :type => 'application/pdf',
      :filename => 'Unshipped_Shingles.pdf')
  end

end
