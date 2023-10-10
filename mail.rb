require 'net/smtp'
require 'mail'

class SendEmail

    def emailRecc(webScrapedInfo)

        
        #Get user email
        puts "Would you like the student orginazation information emailed to you?(y or n)"
        answ = gets.chomp.downcase

        if answ == 'y'
            puts "Please enter your email address: "
            user_email = gets.chomp
            
            #Set up email options
            options = {
                :address => "smtp.gmail.com", 
                :port => 587,
                :user_name => "StudentOrgInfo@gmail.com", 
                :password => "axka ynxy zego wjog", 

                :authentication => 'plain'}

            Mail.defaults do
                delivery_method :smtp, options
            end

            #Used to create the email
            mail = Mail.new do
                from    'StudentOrgInfo@gmail.com'
                to      user_email
                subject 'OSU Student Organization Info'
                body    webScrapedInfo
                add_file 'student_org.txt'
            end

            mail.deliver!


            puts "Email sent successfully!"
        else
            puts "email not sent!"
    	end
   end

   def send_contact_email(email_address, subject, message)
    # Set up email options
    options = {
      address: 'smtp.gmail.com',
      port: 587,
      user_name: 'StudentOrgInfo@gmail.com',
      password: 'axka ynxy zego wjog',
      authentication: 'plain'
    }

    Mail.defaults do
      delivery_method :smtp, options
    end

    # Used to create the email
    mail = Mail.new do
      from 'StudentOrgInfo@gmail.com'
      to email_address
      subject subject
      body message
    end
    
    mail.deliver!
  end

end
