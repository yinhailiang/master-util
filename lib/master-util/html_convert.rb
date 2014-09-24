module HtmlConvert
  def self.to_elements(receiver)
    article_element = []
    receiver.gsub! /\r|\n|\t/, ''
    imgs_rex = /<img\s.*?\s?src\s*=\s*['|"]?([^\s'"]+).*?>/i
    img_rex = /<img[^>]*>/i 
    if !receiver.match(img_rex)
      article_element << { type: "text", content: receiver}
    else
      imgs_src = receiver.scan(img_rex)
      img_and_anchor_ary = []
      imgs_src.each do |img_src|
        img_and_anchor_ary << { type:"img", start_index: receiver.index(img_src), content: img_src } 
      end
      img_and_anchor_ary.sort_by!{|e| e[:start_index]}
      img_and_anchor_ary.each_with_index do |se, index|
        if index == 0
          article_element << { type: "text", content: receiver[0, se[:start_index]] }
        end
        article_element << { type: "image", url: se[:content].scan(imgs_rex)[0][0] }
        se_end_index = se[:start_index] + se[:content].length
        article_element << if index == img_and_anchor_ary.length - 1
          { type: "text", content: receiver[se_end_index, receiver.length - se_end_index] }
        else
          { type: "text", content: receiver[se_end_index, img_and_anchor_ary[index + 1][:start_index] - se_end_index] }
        end
      end
    end
    article_element.select{|e| e[:type] == 'text' ? !e[:content].blank? : true}
  end
end