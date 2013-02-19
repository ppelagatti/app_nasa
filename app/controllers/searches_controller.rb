class SearchesController < InheritedResources::Base
  def show

    @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)

    if params[:search].length < 1
      redirect_to searches_path
    else
    @sea = Search.search(params[:search])
    if @sea.length<1
      Search.create(:text => params[:search])
    end
    @sea = Search.search(params[:search])

    @sea.each do |search|
       @search = search.text
    end
    @v = @yt_session.videos_by(:query => @search, :per_page => 50)
    @a=Array.new()
    @b=Array.new()
    @c=Array.new()
    @d=Array.new()
    @urls=Array.new()
    @v.videos.each do |ccc|
      @a << ccc.view_count
      @b << ccc.rating
      @c << ccc.title
      @d << ccc.duration
      @urls << ccc.player_url
    end

    $i = 0
    $num = @b.length
    begin
      if @b[$i] && @a[$i] && (@a[$i]>20000) && @d[$i] && (@d[$i]<450)
        if @result
          if @result > (@a[$i]/(@b[$i].likes+0.5)+5000*(@b[$i].dislikes/(@b[$i].likes+0.5)))
            @result = (@a[$i]/(@b[$i].likes+0.5)+5000*(@b[$i].dislikes/(@b[$i].likes+0.5)))
            @final = @c[$i]
            @ur = @urls[$i]
          end
        else
          @result = (@a[$i]/(@b[$i].likes+0.5)+5000*(@b[$i].dislikes/(@b[$i].likes+0.5)))
          @final = @c[$i]
          @ur = @urls[$i]
        end
      end
      $i +=1
    end while $i < $num
  end
  end




def new

end


end