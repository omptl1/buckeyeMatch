require 'net/smtp'
require 'mail'

class SendEmail

    def email(webScrapedInfo)
        
        #Get user email
        puts "Would you like the student orginazation information emailed to you?(y or n)"
        answ = gets.chomp.downcase

        if answ == 'y'
            puts "Please enter your email address: "
            user_email = gets.chomp
            
            #Set up email options
            options = {:address => "smtp.gmail.com", :port => 587, :user_name => "StudentOrgInfo@gmail.com", :password => "OSUNetwork2023", :authentication => 'plain'}

            Mail.defaults do
                delivery_method :smtp, options
            end

            #Used to create the email
            mail = Mail.new do
                from    'StudentOrgInfo@gmail.com'
                to      user_email
                subject 'OSU Student Organization Info'
                body    webScrapedInfo
            end

            #Used to send the email
            mail.deliver!

            puts "Email sent successfully!"
        else
            puts "email not sent!"
    	end
   end
end
