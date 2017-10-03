module Redmine
  module Export
    module PDF
      module ShinglePdfHelper

        def new_shingles_to_pdf
          pdf = RBPDF.new
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(10, 20, 10)

          Issue.where("tracker_id = 30 AND status_id <> 9").each do |shingle|
            names = shingle.description.split /[\r\n]+/
            names.shift if names.first == ""
            names.shift if names.first == "Full name for shingle (31 character max)"
            names.shift if names.first == "Active Number (integer only)"
            members = names.each_slice(2).to_a

            chapter = shingle.custom_field_value(134).to_s
            university = shingle.custom_field_value(135).to_s
            initiation_date = Date.strptime(shingle.custom_field_value(136).to_s, "%m/%d/%Y").strftime('%B %-d, %Y')

            members.each do |member|
              member_name = member[0].gsub('&quot;', "\"").strip
              member_number = member[1].gsub(/[^0-9]/, '').strip
              new_shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
            end
          end

          pdf.output
        end
        
        def new_shingle_to_pdf(shingle)
          pdf = RBPDF.new
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(10, 20, 10)

          names = shingle.description.split /[\r\n]+/
          names.shift if names.first == ""
          names.shift if names.first == "Full name for shingle (31 character max)"
          names.shift if names.first == "Active Number (integer only)"
          members = names.each_slice(2).to_a

          chapter = shingle.custom_field_value(134).to_s
          university = shingle.custom_field_value(135).to_s
          initiation_date = Date.strptime(shingle.custom_field_value(136).to_s, "%m/%d/%Y").strftime('%B %-d, %Y')

          members.each do |member|
            member_name = member[0].gsub('&quot;', "\"")
            member_number = member[1].gsub(/[^0-9]/, '')
            new_shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
          end

          pdf.output
        end

        def new_shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
          font = 'canterbury'
          pdf.add_page('P','LETTER',true,false)
          pdf.set_font(font,'', 48)
          pdf.write(5, 'Alpha Gamma Omega', '', 0, 'C', true)
          crest = Rails.root.join('files', 'shingles', 'crest.png').to_s
          pdf.image(crest)
          pdf.set_font(font,'', 34)
          pdf.write(5, 'Fraternity', '', 0, 'C', true)

          pdf.ln(10)
          pdf.set_font(font,'I', 16)
          pdf.write(5, 'This is to certify that', '', 0, 'C', true)
          pdf.set_font(font,'', 34)
          pdf.write(5, member_name, '', 0, 'C', true)
          pdf.set_font(font,'I', 16)
          pdf.write(5, 'is a member of Alpha Gamma Omega Fraternity', '', 0, 'C', true)
          pdf.write(5, 'and is entitled to all the rights and privileges of the', '', 0, 'C', true)
          pdf.write(5, "\"Fraternity for Eternity\"", '', 0, 'C', true)

          pdf.ln(10)
          pdf.write(5, "Member Number " + member_number + ", " + chapter + " Chapter", '', 0, 'C', true)
          pdf.write(5, "Initiated on " + initiation_date  + " at", '', 0, 'C', true)
          pdf.write(5, university, '', 0, 'C', true)
        end

        def shingles_to_pdf
          pdf = RBPDF.new
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(10, 148, 10)

          Issue.where("tracker_id = 30 AND status_id <> 9").each do |shingle|
            names = shingle.description.split /[\r\n]+/
            names.shift if names.first == ""
            names.shift if names.first == "Full name for shingle (31 character max)"
            names.shift if names.first == "Active Number (integer only)"
            members = names.each_slice(2).to_a

            chapter = shingle.custom_field_value(134).to_s
            university = shingle.custom_field_value(135).to_s
            initiation_date = Date.strptime(shingle.custom_field_value(136).to_s, "%m/%d/%Y").strftime('%B %-d, %Y')

            members.each do |member|
              member_name = member[0].gsub('&quot;', "\"").strip
              member_number = member[1].gsub(/[^0-9]/, '').strip
              shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
            end
          end

          pdf.output
        end
        
        def shingle_to_pdf(shingle)
          pdf = RBPDF.new
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(10, 148, 10)

          names = shingle.description.split /[\r\n]+/
          names.shift if names.first == ""
          names.shift if names.first == "Full name for shingle (31 character max)"
          names.shift if names.first == "Active Number (integer only)"
          members = names.each_slice(2).to_a

          chapter = shingle.custom_field_value(134).to_s
          university = shingle.custom_field_value(135).to_s
          initiation_date = Date.strptime(shingle.custom_field_value(136).to_s, "%m/%d/%Y").strftime('%B %-d, %Y')

          members.each do |member|
            member_name = member[0].gsub('&quot;', "\"")
            member_number = member[1].gsub(/[^0-9]/, '')
            shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
          end

          pdf.output
        end

        def shingle_page(pdf, member_name, member_number, chapter, initiation_date, university)
          font = 'times'
          pdf.add_page('P','LETTER',true,false)
          pdf.set_font(font,'', 34)
          pdf.write(5, member_name, '', 0, 'C', true)
          pdf.set_font(font,'I', 16)
          pdf.ln(32)
          pdf.write(5, "Member Number " + member_number + ", " + chapter + " Chapter", '', 0, 'C', true)
          pdf.write(5, "Initiated on " + initiation_date  + " at", '', 0, 'C', true)
          pdf.write(5, university, '', 0, 'C', true)
        end

        def shingles_invoices_pdf
          pdf = RBPDF.new
          pdf.set_print_header(false)
          pdf.set_print_footer(false)
          pdf.set_margins(15, 20, 15)

          issues = Issue.where("tracker_id = 30 AND status_id <> 9")
          issues = issues.joins('INNER JOIN custom_values ON (issues.id = custom_values.customized_id)').where('custom_values.custom_field_id = 121')
          street_addresses = issues.map { |i| i.custom_field_value(121).split(";").first.downcase.strip }.uniq
          
          street_addresses.each do |street_address|
            invoice_shingles = []
            issues.each do |i|
              if i.custom_field_value(121).split(";").first.downcase.strip == street_address
                invoice_shingles << i
              end
            end

            chapter = invoice_shingles.last.custom_field_value(134).to_s
            address = Setting.plugin_redmine_fraternity_members['address'].to_s
            ship_to_name = invoice_shingles.last.custom_field_value(138).to_s
            ship_to_address = invoice_shingles.last.custom_field_value(121).split (";")
            ship_to_address = ship_to_address.join("\r\n")
            date = Date.today.strftime('%B %-d, %Y')

            members = []
            invoice_shingles.each do |shingle|
              names = shingle.description.split /[\r\n]+/
              names.shift if names.first == ""
              names.shift if names.first == "Full name for shingle (31 character max)"
              names.shift if names.first == "Active Number (integer only)"
              members += names.each_slice(2).to_a
            end

            invoice_page(pdf, address, date, chapter, ship_to_name, ship_to_address, members)
          end

          pdf.output
        end

        def invoice_page(pdf, address, date, chapter, ship_to_name, ship_to_address, members)
          font = 'times'
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
          members.each do |member|
            pdf.cell(24, 0, member[1].gsub(/[^0-9]/, ''), 0, 0, 'L', 0)
            pdf.cell(0, 0, member[0].gsub('&quot;', "\""), 0, 0, 'L', 0)
            pdf.ln(5)
          end
        end

      end
    end
  end
end
