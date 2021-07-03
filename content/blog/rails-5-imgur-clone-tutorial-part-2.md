+++
title = "Rails 5 Imgur Clone Tutorial…Part 2"
date = "2017-05-08"
author = "Priom"
+++

![Rails 5 Imgur Clone](https://cdn-images-1.medium.com/max/5120/1*T_hnqYrj61dyo1TVPrDolw.jpeg)

# Rails 5 Imgur Clone Tutorial…Part 2

Welcome to the second and final part of the Rails 5 Imgur clone, in this part, we will build the image uploading, manage configurations and then deploy to Heroku.

> Be sure to check out the first part [here](https://medium.com/@priom/rails-5-imgur-clone-tutorial-part-1-8fa6e08d5d) if you haven’t already.

> First, signup and verify a new cloudinary account by going [here](http://cloudinary.com/invites/lpov9zyyucivvxsnalc5/vvf3cm3nlh4z8lk5ndii), it’s my referral link to cloudinary which will give me little bit extra space.

Let’s start by adding few more variables to our cloudinary configuration at **_config/initializers/cloudinary.rb_**

Remember, the **_cloudinary.rb_** has to exactly in that folder, if you open the **_config/application.rb_** you’ll see in the comments written it says the config has to be there, it’s just how rails configuration works.

Make sure your **cloudinary.rb** looks something like this.

```
Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
    config.cdn_subdomain = true
    config.enhance_image_tag = true
end
```

Go to cloudinary dashboard and you will the **_Cloud name, API Key, API Secret_** variables which we will use. The inclusion of **_cdn_subdomain_** increases image serving performance by getting the best cdn location and **_enhance_image_tag_** adds more functions to the built in rails **_image_tag_** method.

> Okay, here we are dynamically setting environment variables to our application. It will pick up variables for production and development environments. You really don’t wanna hard code this as it is not safe and wise to publicize your keys and other info as these are highly sensitive. This style is highly recommended for any of your rails project not just this. It’s just really a damn good practice. You might think its just a home project but if you work at a company this is really serious so, it’s better to practice from now.

Secondly, and this is the most important step, setting up your variables in your environment. We are going to use the **_dotenv_** gem. Add this to your **Gemfile** and run **_bundle_** in your terminal to install the gem and then restart your server.

```
gem 'dotenv-rails', groups: [:development, :test]
```

> This is by far the best, easiest and simple solution and works perfectly.

Now go to project’s root directory and create a file called **_.env_**

We are going to set our variables like this.

```
export CLOUDINARY_CLOUD_NAME=
export CLOUDINARY_API_KEY=
export CLOUDINARY_API_SECRET=
```

Just put the variables as it is without any quotes. And then add **_.env_** to your **_.gitignore_** so that it doesn’t get pushed to your GitHub repo. We are going to add Heroku cloudinary add-on and set the variable in the production environment in their way.

Alright, our configuration part is done for now. If you wanna further know about the **dotenv** gem then go to their [github page](https://github.com/bkeepers/dotenv) and read more.

Finally, we are going to add code to our controller for uploading and saving images to the database.

Go to your controller at **_pics_controller.rb_** and add to your **_new_** & **_create_** method like this.

```
def new
  @pic = Pic.new
end

def create
  @pic = Pic.new(params.require(:pic).permit(:image))
  @pic.save
  redirect_to @pic
end
```

What we are doing here is basically creating an **instance variable** called **_@pic_** and adding the **_new_** method to our **_Pic_** model which we will use it in all over our project. Later, in the create method we are allowing it to add to the database, then save it and take it to that pic page after it’s been saved to our database.

Now, create a **_new.html.erb_** & **_form.html.erb_** in **_app/views/pics/_** directory

In your **_form.html.erb_** add this code.

```
<%= form_for @pic do |f| %>
  <%= f.label :image do %>
    <%=  f.hidden_field :image_cache %>
    <%=  f.file_field :image %>
  <% end %>
    
  <%= f.submit %>
<% end %>
```

So, here we are creating a form for a pic to be added to our database and then we are going to display it in the web.

Now, we going to implement the show page and controller.

In your **_pics_controller.rb_** add this following code

```
def show
  @pic = Pic.find(params[:id])
end
```

Here we are pulling the data from database by their **_id_**

Create a new file **_show.html.erb_** in **_app/views/pics/_** directory and this simple line to display the image to the public

```
<%= image_tag(@pic.image.url, width: '100%', crop: "scale")  %>
```

We are also scaling the image to fit in the display so, that it looks beautiful.

Great, your image is displayed now we are going to display all the images to our index/ home page. Open **_pics_controller.rb_** add this following code to **_index_** controller to get all the images from the database

```
def index
  @pics = Pic.all
end
```

In your **_index.html.erb_** add this to loop through all the images and display it to the index page.

```
<% @pics.each do |pic| %>
    <%=  image_tag(pic.image.url, width: '100%', crop: "scale")  %>
<% end %>
```

Now, we are going to prettify our app a little by adding simple bootstrap css and a navigation.

Go to [bootstrap](https://bootswatch.com/paper/bootstrap.min.css), it’s a bootstrap material design flavor which I really like, you could use this or anything else you like. Grab the link add it to the **_head_** of your **_application.html.erb_** right below the csrf meta tags

```
<link rel="stylesheet" href="https://bootswatch.com/paper/bootstrap.min.css">
```

Now, create a **_partial_** named **_header.html.erb_** inside the **_app/views/layouts/_** directory, and add the navigation to our header

```
<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <%= link_to 'Rimgur', root_path, class: 'navbar-brand' %>
      <%= link_to 'New Post', new_pic_path, class: 'navbar-brand' %>
    </div>
  </div>
</nav>
```

And then render the header to our main application page. Add this to your **_application.html.erb_** on top **_yield_**

```
<%= render 'layouts/header' %>
```

Now, as a final step we are going to take our app live by deploying it to heroku.

For our application to work on production, we need to do some modification to our **_Gemfile._** Move the **_gem ‘sqlite’_** to **_development_** group and add **_pg_** for **_PostgreSQL_** for **_production._**

```
group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
```

Then do this following to install the gems

> bundle

> gem install bundler

Git add and commit all of your files.

> git add .; git commit -m ‘project finished’

Create a new git repo in your account and our codebase to it. Follow the instructions on the screen to do **_git remote add and push_**.

Now, we are ready to take it live. Create a new [heroku](https://www.heroku.com/) account for FREE and verify it. Then, create a new heroku app in your terminal and push it.

> heroku create

> git push heroku master

We are going to have migrate our schema to production for our app to work. We can do it like this.

> heroku run rails db:migrate

Do **_heroku open_** to open the app in browser.

Okay, now you are going to do the most important step for our image uploading to work.

> heroku addons:create cloudinary:starter

Remember, we set up the environment variables for [cloudinary](https://hackernoon.com/tagged/cloudinary) for [development](https://hackernoon.com/tagged/development) machine, now we are going to do it for our production.

Go to your heroku dashboard, then to your app, and then to the cloudinary dashboard to get our configurations.

Now, in your terminal do this following to add the config variables.

> heroku config:set CLOUDINARY_CLOUD_NAME=

> heroku config:set CLOUDINARY_API_KEY=

> heroku config:set CLOUDINARY_API_SECRET=

Try uploading a pic in your app and then check the cloudinary dashboard that it’s been added.

Congratulations, you have successfully built a fully functional web app. Feel free to play around with it and make it more awesome.

Here is the link to my github [repo](https://github.com/priom/rimgur). All the code is hosted here for your reference.

> Thank you for reading it, hope you enjoyed it and will use this knowledge to build something awesome.

> LIKE & SHARE if you have liked my post. Please comment below any feedbacks, suggestions or requests. Also please visit my [website](http://priom.dev). Subscribe me if you would like to receive future posts to your inbox.
