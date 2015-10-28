class ApplicationMailer < ActionMailer::base
	default from: "from@example.com"
	layout 'mailer' 
end