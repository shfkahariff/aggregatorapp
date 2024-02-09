class GenerateArticlesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Get headlines and urls
    headlines = []
    title_urls = []
    publishdate = []
  
    # Scrape pages 2 and 3
    (1..5).each do |page|
      puts "Scraping page #{page}"
      url = "https://mashable.com/articles?page=#{page}"
      response = HTTParty.get(url)
      doc = Nokogiri::HTML(response.body)
      
      content_list = doc.css('.justify-center[data-module="content-list"]')
      
      content_list.css('div[data-ga-element="content-stripe"] a.block[data-ga-item="title"]').each do |a|
        date = Date.parse(a.parent.css('time').first['datetime'])
        puts "Article date: #{date}"
        if date < Date.new(2022, 1, 1)
          puts "Skipping article published before 2022"
          next
        end
    
        headlines << a.text.strip.gsub("\n", "")
        title_urls << URI.join('https://mashable.com/', a['href']).to_s
        publishdate << date
      end
    
      headlines.each_with_index do |headline, index|
        existing_post = Post.find_by(headlines: headline)
        if existing_post
          puts "Skipping existing post: #{headline}"
          next
        end
    
        post = Post.create(headlines: headline, titleurl: title_urls[index], publishdate: publishdate[index])
        if post.persisted?
          puts "Post saved successfully"
        else
          puts "Error saving post: #{post.errors.full_messages.join(", ")}"
        end
      end
    end
  
  end
end

