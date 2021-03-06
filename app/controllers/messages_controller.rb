class MessagesController < ApplicationController
  def create
    @chatroom = Chatroom.find(params[:chatroom_id])
    @message = Message.new(message_params)
    @message.chatroom = @chatroom
    @message.user = current_user
    @game = @chatroom.game
    # if @message.save
    #   redirect_to game_path(@game, anchor: "message-#{@message.id}")
    # end
    if @message.save
      ChatroomChannel.broadcast_to(
        @chatroom,
        render_to_string(partial: "message", locals: {message: @message})
      )
      head :ok
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end

