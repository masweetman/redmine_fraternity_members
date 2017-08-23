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
            #if shingle.project.parent_id == 6

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

            #end
          end

          pdf.output
 
        end

        def shingles_invoices_pdf
          pdf = RBPDF.new
          font = 'times'
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(15, 20, 15)

          shingles = Issue.where("tracker_id = 7 AND status_id <> 9").order("project_id")
          shingles = shingles.joins('INNER JOIN custom_values ON (issues.id = custom_values.customized_id)').where('custom_values.custom_field_id = 121') 

          shingles.group('custom_values.value').count.each do |ship_address|

            invoice_shingles = shingles.where('custom_values.value = ?', ship_address[0])
            chapter = invoice_shingles.last.project.name
            address = Setting.plugin_redmine_fraternity_members['address'].to_s
            ship_to_name = invoice_shingles.last.author.name
            ship_to_address = ship_address[0]
            date = Date.today.strftime('%B %-d, %Y')

            pdf.add_page('P','LETTER',true,false)

            pdf.set_font(font,'B', 14)
            pdf.cell(50, 0, "Alpha Gamma Omega", 0, 0, 'L', 0)
            pdf.cell(0, 0, "SHINGLE INVOICE", 0, 0, 'R', 0)
            pdf.ln(6)

            pdf.set_font(font,'', 12)
            pdf.write(5, address, '', 0, 'L', true)
            pdf.ln(10)

            pdf.set_font(font,'', 12)
            pdf.write(5, "Date: " + date, '', 0, 'L', true)
            pdf.ln(5)

            pdf.set_font(font,'B', 12)
            pdf.write(5, "Ship to", '', 0, 'L', true)
            pdf.set_font(font,'', 12)
            pdf.write(5, chapter + " Chapter", '', 0, 'L', true)
            pdf.write(5, "ATTN: " + ship_to_name, '', 0, 'L', true)
            pdf.write(5, ship_to_address, '', 0, 'L', true)
            pdf.ln(10)

            pdf.set_font(font,'B', 12)
            pdf.cell(24, 0, "Active No.", 0, 0, 'L', 0)
            pdf.cell(0, 0, "Name", 0, 0, 'L', 0)
            pdf.ln(5)

            pdf.set_font(font,'', 12)
            invoice_shingles.each do |shingle|
                pdf.cell(24, 0, shingle.custom_field_value(24), 0, 0, 'L', 0)
                pdf.cell(0, 0, shingle.custom_field_value(83), 0, 0, 'L', 0)
                pdf.ln(5)
            end

          end

          pdf.output

        end

      end
    end
  end
end
