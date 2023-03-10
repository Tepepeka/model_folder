class Scrapper


    def open_page(url)
        return Nokogiri::HTML(URI.open(url))
    end


    def scrap_cities_name(page)
        cities_array = []
        page.xpath('//tr[3]//td[1]//p/a').each do |link|
            cities_array << link.text
            cities_array.each{|city| city.gsub!(" ","-")}
        end
        return cities_array
    end


    def scrap_email_address(arr1)
        email_array = []
        arr1.each do |city|
            page_city = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/95/#{city.downcase}"))
            email_city = page_city.xpath('//section[2]//tr[4]//td[2]').text
            email_array << email_city
        end
        return email_array
    end


    def hash_into_array(arr1,arr2)
        cities_email_array = []
        (arr1.length).times do |i|
            cities_mail_hash = {}
            cities_mail_hash[arr1[i]] = arr2[i]
            cities_email_array << cities_mail_hash
        end
        return cities_email_array
    end


    def save_as_json(array)
        File.open("db/emails.json","w") do |f|
            f.write(array.to_json)
        end
        puts "Saved as json!"
    end


    def save_as_csv(array)
        CSV.open("db/emails.csv", "w") do |csv|
            array.each do |hash|
              csv << [hash.keys.first, hash.values.first]
            end
        end
          puts "Saved as csv!"
    end

    
    def save_as_spreadsheet(array)
        session = GoogleDrive::Session.from_config("config.json")
        spreadsheet = session.create_spreadsheet(title = "emails")
        ws = spreadsheet.worksheets[0]
        ws[1, 1] = "City"
        ws[1, 2] = "Email"
        array.each_with_index do |pair, line|
            ws[line + 2, 1] = pair.keys[0]
            ws[line + 2, 2] = pair.values[0]
        end
        ws.save
        puts "Saved to google drive!"
    end


    def perform
        page = open_page("http://annuaire-des-mairies.com/val-d-oise")
        arr1 = scrap_cities_name(page)
        arr2 = scrap_email_address(arr1)
        cities_email_array = hash_into_array(arr1,arr2)
        save_as_json(cities_email_array)
        save_as_csv(cities_email_array)
        save_as_spreadsheet(cities_email_array)
    end

    
end