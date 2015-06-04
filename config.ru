require "./lib/codebreaker_rack"

use Rack::Reloader
use Rack::Static, :urls => ["/stylesheets"], :root => "public"

run Codebreaker_rack.new
