class ShingleController < ApplicationController
  unloadable

        def shingle_export
                shingle = Issue.find(params[:id])

shingle_html = '<html xmlns:v="urn:schemas-microsoft-com:vml"'
shingle_html += 'xmlns:o="urn:schemas-microsoft-com:office:office"'
shingle_html += 'xmlns:w="urn:schemas-microsoft-com:office:word"'
shingle_html += 'xmlns:m="http://schemas.microsoft.com/office/2004/12/omml"'
shingle_html += 'xmlns="http://www.w3.org/TR/REC-html40">'
shingle_html += '<head>'
shingle_html += '<meta http-equiv=Content-Type content="text/html;charset=UTF-8">'
shingle_html += '<meta name=ProgId content=Word.Document>'
shingle_html += '<meta name=Generator content="Microsoft Word 14">'
shingle_html += '<meta name=Originator content="Microsoft Word 14">'
shingle_html += '<style>'
shingle_html += '</style>'
shingle_html += '</head>'
shingle_html += '<body lang=EN-US style=\'tab-interval:36.0pt;font-family:"Times New Roman","serif"\'>'
shingle_html += '<div>'
shingle_html += '<p align=center>'
shingle_html += '<br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br><br>'
shingle_html += '<span style=\'font-size:36.0pt\'>'
shingle_html += shingle.custom_field_value(83)
shingle_html += '</span>'
shingle_html += '<br><br><br><br><br><br><br><br>'
shingle_html += '<i><span style=\'font-size:17.0pt\'>'
shingle_html += 'Member Number '
shingle_html += shingle.custom_field_value(24)
shingle_html += ', ' + shingle.project.name + ' Chapter'
shingle_html += '<br><br>'
shingle_html += 'Initiated on '
shingle_html += shingle.custom_field_value(23)
shingle_html += ' at '
shingle_html += shingle.custom_field_value(97)
shingle_html += '</span></i>'
shingle_html += '</p>'
shingle_html += '</div>'
shingle_html += '</body>'
shingle_html += '</html>'

				
                send_data(shingle_html, :type => 'text/doc',
                	:filename => shingle.project.name.to_s + '_' + shingle.custom_field_value(24).to_s + '_shingle.doc')
        end

end
