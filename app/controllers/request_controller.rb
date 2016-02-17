class RequestController < ApplicationController
  def index
    begin 
      Spaceship::Tunes::login
      app = Spaceship::Tunes::Application.find("com.instanews.ios")
      app.add_external_tester!(email: params[:email])
    rescue RuntimeError => err
      print params[:email] + " is already a beta tester"
      puts err

      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    rescue => err
      print "Failed to add " + params[:email] + " to the beta testers\n"
      puts err

      render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
    end
  end
end
