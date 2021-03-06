module MasterUtil
  module HtmlConvert extend self
    def to_elements(receiver)
    article_element = []
    #receiver.gsub! /<\/?p[^>]*>/i, ''
    receiver.gsub! /\r|\n|\t/, ''
    imgs_rex = /<img\s.*?\s?src\s*=\s*['|"]?([^\s'"]+).*?>/i
    #href_rex = /<a[^>]*href=["'](?<url>[^"']*?)["'][^>]*>(?<text>[\w\W]*?)<\/a>/ 
    #a_rex = /<a[^>]+>[^>]+a>/
    img_rex = /<img[^>]*>/i 
    v_rex = /<embed[^>]*>/i
    vid_rex = /<embed[^>]*?url\s*=\s*['|"]?([^\s'"]+).*?coverurl\s*=\s*['|"]?([^\s'"]+).*?>/i
    if !receiver.match(v_rex) && !receiver.match(img_rex)
      article_element << { type: "text", content: receiver }
    else
      a_links = receiver.scan(v_rex)
      imgs_src = receiver.scan(img_rex)
      img_and_anchor_ary = []
      a_links.each do |a_link|
        img_and_anchor_ary << { type:"video", start_index: receiver.index(a_link), content: a_link }
      end
      imgs_src.each do |img_src|
        img_and_anchor_ary << { type:"img", start_index: receiver.index(img_src), content: img_src } 
      end
      img_and_anchor_ary.sort_by!{|e| e[:start_index]}
      img_and_anchor_ary.each_with_index do |se, index|
        if index == 0
          article_element << { type: "text", content: receiver[0, se[:start_index]] }
        end
        article_element << if se[:type] == 'video'
          { type: "video", url: se[:content].scan(vid_rex)[0][0], coverurl: se[:content].scan(vid_rex)[0][1] }
        else
          { type: "image", url: se[:content].scan(imgs_rex)[0][0] }
        end
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
  
end