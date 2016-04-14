git add -A
git commit -m "working"
git push heroku master
heroku pg:reset DATABASE --confirm wolfonenight
heroku run rake db:migrate
heroku run rake db:seed