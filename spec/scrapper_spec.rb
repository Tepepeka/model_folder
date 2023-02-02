require_relative '../lib/app/scrapper'


describe "the open uri page method" do
    it "should return a nokogiri document" do
        expect(open_page("http://annuaire-des-mairies.com/val-d-oise").class).to eq(Nokogiri::HTML4::Document)
    end
end


describe "the scrap cities name method" do
    it "should return an array of cities name" do
        expect(scrap_cities_name(Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise"))).nil?).to eq(false)
    end
end


describe "the scrap email address method" do
    it "should return an array of email address" do
        expect(scrap_email_address(["VILLIERS-LE-BEL"]).nil?).to eq(false)
    end
end


describe "te hash into array method" do
    it "should make an array of hash of cities/email" do
        expect(hash_into_array(["Toulouse"],["Toulouse@love"])).to eq([{"Toulouse"=>"Toulouse@love"}])
    end
end