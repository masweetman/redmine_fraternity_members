include Redmine::Export::PDF::ShinglePdfHelper

class ShingleController < ApplicationController
	#unloadable
	before_filter :authorize_global, :only => [:mark_as_shipped, :mark_all_as_shipped]

	def index
	  @project = Project.find(6)
	  @shingles = Issue.where("tracker_id = 7 AND status_id <> 9").order("project_id")
	end

	def mark_all_as_shipped
	  @project = Project.find(6)
          shingles = Issue.where("tracker_id = 7 AND status_id <> 9").order("project_id")
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
            	:filename => shingle.project.name.to_s + '_' + shingle.custom_field_value(24).to_s + '_shingle.pdf')
        end

        def shingles_export_pdf
			send_data(shingles_to_pdf, :type => 'application/pdf',
            	:filename => 'Unshipped_Shingles.pdf')
        end

        def shingle_export_html
	        shingle = Issue.find(params[:id])
	        initiation_date = Date.parse(shingle.custom_field_value(23).to_s)
	        initiation_date = initiation_date.strftime('%B %-d, %Y')

			shingle_html = '<html xmlns:v="urn:schemas-microsoft-com:vml"
							xmlns:o="urn:schemas-microsoft-com:office:office"
							xmlns:w="urn:schemas-microsoft-com:office:word"
							xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"
							xmlns="http://www.w3.org/TR/REC-html40">
							<head>
							<meta http-equiv=Content-Type content="text/html;charset=UTF-8">
							<meta name=ProgId content=Word.Document>
							<meta name=Generator content="Microsoft Word 14">
							<meta name=Originator content="Microsoft Word 14">
							<style>
							p.big {
								line-height: 2425%;
							}
							</style>
							</head>
							<body lang=EN-US style=\'tab-interval:34.0pt;font-family:"Times New Roman","serif"\'>
							<div>
							<p align=center class=\'big\'>
							<br>
							</p>
							<p align=center>
							<span style=\'font-size:34.0pt\'>'
			shingle_html += shingle.custom_field_value(83).to_s
			shingle_html += '</span>
							<br><br><br><br><br><br><br><br>
							<i><span style=\'font-size:16.0pt\'>
							Member Number '
			shingle_html += shingle.custom_field_value(24).to_s + ', '
			shingle_html += shingle.project.name.to_s + ' Chapter' + '<br>Initiated on '
			shingle_html += initiation_date + ' at<br>'
			shingle_html += shingle.custom_field_value(97).to_s + '</span></i></p></div></body></html>'

	        send_data(shingle_html, :type => 'text/doc',
	        	:filename => shingle.project.name.to_s + '_' + shingle.custom_field_value(24).to_s + '_shingle.doc')
        end

end
