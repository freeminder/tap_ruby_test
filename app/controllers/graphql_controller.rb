class GraphqlController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format =~ %r{application/json} }

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
     current_user: current_user,
     login: method(:sign_in)
    }
    result = TapRubySchema.execute(
      query, 
      variables: variables, 
      context: context, 
      operation_name: operation_name
    )
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private
  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { 
      error: { 
        message: e.message, 
        backtrace: e.backtrace 
      }, 
      data: {} 
    }, status: 500
  end

  def current_user
    token_from_request = request.headers['Authorization'].split(' ').last
    decoded_token = JWT.decode(token_from_request, ENV["DEVISE_JWT_SECRET_KEY"], true)
    user = User.find_by(jti: decoded_token.first["jti"])
  end
end
