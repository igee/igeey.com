xml.instruct! :xml, :version=>"1.0" 
xml.rss :version=>"2.0" do
  xml.channel do
    xml.title("爱聚博客")
    xml.link("http://www.igeey.com")
    xml.description("公益从发现开始...")
    xml.language("zh-cn")
    for blog in @blogs
      xml.item do
        xml.title blog.title
        xml.description blog.content
        xml.pubDate xml.cdata!(blog.created_at.to_s(:rfc2822))
        xml.link blog_url(blog)
      end
    end
  end
end