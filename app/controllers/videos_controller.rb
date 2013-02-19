class VideosController < InheritedResources::Base

  def upload
    #@video = Video.create(params[:video])
   @yt_session ||= YouTubeIt::Client.new(:username => YouTubeITConfig.username , :password => YouTubeITConfig.password , :dev_key => YouTubeITConfig.dev_key)

    @projects = Video.search(params[:search])

    @v = @yt_session.videos_by(:query => video_path, :per_page => 50)
    @a=Array.new()
    @b=Array.new()
    @c=Array.new()
    @d=Array.new()
    @v.videos.each do |ccc|
      @a << ccc.view_count
      @b << ccc.rating
      @c << ccc.title
      @d << ccc.duration
    end

    $i = 0
    $num = @b.length
    begin
      if @b[$i] && @a[$i] && (@a[$i]>5000) && @d[$i] && (@d[$i]<450)
        if @result
          if @result > (@a[$i]/(@b[$i].likes+0.5)+30*(@b[$i].dislikes/@b[$i].likes))
            @result = (@a[$i]/(@b[$i].likes+0.5)+30*(@b[$i].dislikes/@b[$i].likes))
            @final = @c[$i]
          end
        else
          @result = (@a[$i]/(@b[$i].likes+0.5)+30*(@b[$i].dislikes/@b[$i].likes))
          @final = @c[$i]
        end
      end
      $i +=1
    end while $i < $num
  end

  def update
    @video     = Video.find(params[:id])
    @result    = Video.update_video(@video, params[:video])
    respond_to do |format|
      format.html do
        if @result
          redirect_to @video, :notice => "video successfully updated"
        else
          respond_to do |format|
            format.html { render "/videos/_edit" }
          end
        end
      end
    end
  end

  def save_video
    @video = Video.find(params[:video_id])
    if params[:status].to_i == 200
      @video.update_attributes(:yt_video_id => params[:id].to_s, :is_complete => true)
      Video.delete_incomplete_videos
    else
      Video.delete_video(@video)
    end
    redirect_to videos_path, :notice => "video successfully uploaded"
  end

  def destroy
    @video = Video.find(params[:id])
    if Video.delete_video(@video)
      flash[:notice] = "video successfully deleted"
    else
      flash[:error] = "video unsuccessfully deleted"
    end
    redirect_to videos_path
  end

  def add_comment
    @video = Video.find(params[:id])
    if @video.create_comment(params[:video][:comment])
      flash[:notice] = "Comment has been sucessfully added."
    else
      flash[:error] = "Sorry the comment has not been added."
    end
    redirect_to @video    
  end

  protected
    def collection
      @videos ||= end_of_association_chain.completes
    end

end
