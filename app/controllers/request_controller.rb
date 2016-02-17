class RequestController < ApplicationController
  def is_valid_email?(email)
    (email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end


  def decrypt_email(crypt)
    begin
      cipher = OpenSSL::Cipher.new 'AES-256-CBC'
      cipher.decrypt
      pwd = ENV['ENCRYPT_PASSWORD']
      salt = '61490800bb56d8fg4'
      iter = 100000
      key_len = 48 
      digest = OpenSSL::Digest::SHA512.new

      key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)

      cipher.key = key[0..31];
      cipher.iv = key[32..-1];

      puts params[:email]

      email = cipher.update(crypt.scan(/../).map{|b|b.hex}.pack('c*'))
      email << cipher.final

      puts email
      raise ArgumentError, "Invalid email" if !is_valid_email?(email)

      return email
    end
  end

  def index
    begin 
      email = decrypt_email(params[:email])
      Spaceship::Tunes::login
      app = Spaceship::Tunes::Application.find("com.instanews.ios")
      app.add_external_tester!(email: email)
    rescue RuntimeError => err
      print params[:email] + " is already a beta tester\n"
      puts err

      render(:file => File.join(Rails.root, 'public/403.html'), :status => 403, :layout => false)
    rescue => err
      print "Failed to add " + params[:email] + " to the beta testers\n"
      puts err

      render(:file => File.join(Rails.root, 'public/500.html'), :status => 500, :layout => false)
    end
  end
end
