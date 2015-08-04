module Redmine
  module Export
    module PDF
      module ShinglePdfHelper
        
        # Returns a PDF string of a single shingle
        def shingle_to_pdf(shingle)
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
          pdf.set_margins(10, 148, 10)
          pdf.add_page('P','LETTER',true,false)

          pdf.set_font(font,'', 34)

          pdf.write(5, member_name, '', 0, 'C', true)

          pdf.set_font(font,'I', 16)
          
          pdf.ln(32)

          pdf.write(5, "Member Number " + member_number + ", " + chapter + " Chapter", '', 0, 'C', true)
          pdf.write(5, "Initiated on " + initiation_date  + " at", '', 0, 'C', true)
          pdf.write(5, university, '', 0, 'C', true)

          pdf.output
 
        end

        # Returns a PDF string of all open shingles
        def shingles_to_pdf
          pdf = RBPDF.new
          font = 'times'
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(10, 148, 10)

          Issue.where("tracker_id = 7 AND status_id <> 9").order("project_id").each do |shingle|
            if shingle.project.parent_id == 6

              member_name = shingle.custom_field_value(83).to_s
              member_number = shingle.custom_field_value(24).to_s
              chapter = shingle.project.name.to_s
              initiation_date = Date.parse(shingle.custom_field_value(23).to_s).strftime('%B %-d, %Y')
              university = shingle.custom_field_value(97).to_s

              pdf.add_page('P','LETTER',true,false)
              pdf.set_font(font,'', 34)
              pdf.write(5, member_name, '', 0, 'C', true)
              pdf.set_font(font,'I', 16)
              pdf.ln(32)
              pdf.write(5, "Member Number " + member_number + ", " + chapter + " Chapter", '', 0, 'C', true)
              pdf.write(5, "Initiated on " + initiation_date  + " at", '', 0, 'C', true)
              pdf.write(5, university, '', 0, 'C', true)

            end
          end

          pdf.output
 
        end

      end
    end
  end
end
