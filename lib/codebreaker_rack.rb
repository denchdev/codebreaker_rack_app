require 'erb'
require 'bundler/setup'
require 'codebreaker'

class Codebreaker_rack
  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/init" then init    
    when "/check" then check
    when "/hint" then hint
    when "/play_again" then play_again
    when "/begin_" then begin_
    else Rack::Response.new("Not Found", 404)
    end
  end
  
  def init
    Rack::Response.new do |response|
      @game = Codebreaker::Game.new(@request.params['user_name'])
      @game.start
      response.redirect("/")
    end
  end
  
  def play_again
    Rack::Response.new do |response|
      @hint_ = nil
      @guess_ = nil
      @result_ = nil
      @game.start
      response.redirect("/")
    end
  end
  
  def check
    Rack::Response.new do |response|
      @guess_ = @request.params['guess']
      @result_ = @game.check_up @request.params['guess']
      response.redirect("/")
    end
  end
  
  def hint
    Rack::Response.new do |response|      
      @hint_ = @game.hint 0
      response.redirect("/")
    end
  end
  
  def begin_
    Rack::Response.new do |response|      
      @game = nil
      response.redirect("/")
    end
  end
  
  
  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
