module Redmine
  module Export
    module PDF
      module ShinglePdfHelper
        # Returns a PDF string of a single shingle
        def shingle_to_pdf(shingle, assoc={})
          member_name = shingle.custom_field_value(83).to_s
          member_number = shingle.custom_field_value(24).to_s
          chapter = shingle.project.name.to_s
          initiation_date = Date.parse(shingle.custom_field_value(23).to_s).strftime('%B %-d, %Y')
          university = shingle.custom_field_value(97).to_s

          # [member_name]
          # Member Number [member_number], [chapter] Chapter 
          # Initiated on [initiation_date] at
          # [university]

          pdf = RBPDF.new
          font = 'times'
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(15, 27, 15)
          pdf.add_page('P','LETTER',true,false)

          pdf.set_font(font,'', 34)

          pdf.write(5, member_name, '', 0, 'C', true)
          pdf.ln

          pdf.set_font(font,'I', 16)

          pdf.write(5, "Member Number " + member_number + ", " + chapter + " Chapter", '', 0, 'C', true)
          pdf.ln
          pdf.write(5, "Initiated on " + initiation_date  + " at", '', 0, 'C', true)
          pdf.ln
          pdf.write(5, university, '', 0, 'C', true)

          pdf.output
 
        end



      end
    end
  end
end
