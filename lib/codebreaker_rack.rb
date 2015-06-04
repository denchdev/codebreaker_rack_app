require 'erb'
require 'bundler/setup'
require 'codebreaker'

class Codebreaker_rack
  def call(env)
    @request = Rack::Request.new(env)
    case @request.path
    when "/" then Rack::Response.new(render("index.html.erb"))
    when "/init" then init
    when "/start" then start
    when "/check" then check
    else Rack::Response.new("Not Found", 404)
    end
  end
  
  def init
    Rack::Response.new do |response|
      @game = Codebreaker::Game.new(@request.params['user_name'])
      response.redirect("/")
    end
  end
  
  def start
    Rack::Response.new do |response|
      @game.start
      @game.save
      response.redirect("/")
    end
  end
  
  def check
    Rack::Response.new do |response|
      @guess_ = @request.params['guess']
      @result_ = @game.check_up @guess_
      response.redirect("/")
    end
  end
  
  def render(template)
    path = File.expand_path("../views/#{template}", __FILE__)
    ERB.new(File.read(path)).result(binding)
  end
end
