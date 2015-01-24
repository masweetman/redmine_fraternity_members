class ShingleController < ApplicationController
  unloadable

        def shingle_export
                shingle = Issue.find(params[:id])

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
				</style>
				</head>
				<body lang=EN-US style=\'tab-interval:36.0pt;font-family:"Times New Roman","serif"\'>
				<div>
				<p align=center>
				<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>
				<span style=\'font-size:36.0pt\'>'
shingle_html += shingle.custom_field_value(83).to_s
shingle_html += '</span>
				<br><br><br><br><br><br><br><br>
				<i><span style=\'font-size:17.0pt\'>
				Member Number '
shingle_html += shingle.custom_field_value(24).to_s + ', '
shingle_html += shingle.project.name.to_s + ' Chapter' + '<br><br> Initiated on '
shingle_html += shingle.custom_field_value(23).to_s + ' at '
shingle_html += shingle.custom_field_value(97).to_s + '</span></i> </p> </div> </body> </html>'

                send_data(shingle_html, :type => 'text/doc',
                	:filename => shingle.project.name.to_s + '_' + shingle.custom_field_value(24).to_s + '_shingle.doc')
        end

end
