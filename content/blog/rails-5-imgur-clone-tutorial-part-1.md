+++
title = "Rails 5 Imgur Clone Tutorial…Part 1"
date = "2017-05-04"
author = "Priom"
+++

![Rails 5 Imgur Clone](https://cdn-images-1.medium.com/max/5120/1*T_hnqYrj61dyo1TVPrDolw.jpeg)

Handle image upload and [management](https://hackernoon.com/tagged/management) painlessly with Carrierwave and Cloudinary and deploy on [Heroku](https://hackernoon.com/tagged/heroku) and share your photos fast with the world.

Hi everyone, today I’m going to show you how to do image share and upload in your Rails 5 application very easily. This is what I have learned by browsing several outdated tutorials, blog posts and a bunch of documentation. Most of the articles out there are older Rails version 4 so, I hacked together the steps for integrating into Rails 5 which I’m currently using on some of the projects and continue to use more. Plus in the process, we are going to build an imgur clone today by adding all the CRUD (Create, Read, Update, Delete) functionalities.

It is going to be a 2 part series explaining every bits and pieces. This tutorial is going to very beginner friendly and also suitable to intermediate to advanced users.

### Now, let’s start some coding, shall we?

First, let’s create a new rails project in your terminal by doing:

> rails new rimgur

It’s always good practice to start using Git right away so, we are going to follow the same practice here:

> git init

> git add .

> git commit -m ‘project init’

Let’s test our app in the browser by using this command to boot up our server.

> rails server

And then go to _localhost:3000 in your browser. You will see this._

![Rails default home](https://cdn-images-1.medium.com/max/1112/1*5rXDFCXMNuJqPakpckB5-g.png)

Great, your app is running successfully. Open the project in your favorite IDE or text editor.

Now we are going to create a controller.

```
rails generate controller pics
```

Open file **_pics_controller.rb_** and an action **_index_**

```
class PicsController < ApplicationController
    def index
    end
end
```

Create a view file for our index action in **_app/views/pics/index.html.erb_**

Open **index.html.erb** and write some dummy text like _“Hello”_

Now, we are going to create a route to display the page.

Go to **_config/routes.rb_** and write this.

```
Rails.application.routes.draw do
    root 'pics#index'
end
```

Okay, this line simply means you are setting _root_ path to _pic_ controller and _index_ action.

And you should _“Hello”_ or whatever you wrote.

Now, we are going to create our model like this.

```
rails generate model Pic
```

Awesome, now we have some routes and model setup and now we can start integrating our image handling system.

First, open your **_Gemfile_** and then put these right anywhere in middle.

```
gem 'carrierwave'
gem 'cloudinary'
```

Second, run **_bundle_** in your terminal to install the gems and then restart your server.

Third, we will generate our image uploader like this.

```
rails generate uploader Image
```

Go to **_app/uploaders/image_uploader.rb_** and add this inside our class.

```
include Cloudinary::CarrierWave
```

**And comment out everything else in the file. IMPORTANT!**

Now, create a new file in the **_config/initializers_** directory name **_cloudinary.rb_** and then add this.

```
Cloudinary.config do |config|
    config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
    config.api_key = ENV['CLOUDINARY_API_KEY']
    config.api_secret = ENV['CLOUDINARY_API_SECRET']
end
```

Okay, let me explain this. We are adding all the configuration variables dynamically and securely. I’ll explain later more in details.

Open **_app/models/pic.rb_** and then put this.

```
class Pic < ApplicationRecord
    mount_uploader :image, ImageUploader
end
```

And then run `rails db:migrate` to add our schema. Your **_db/schema.rb_** should have something like this:

```
create_table "pics", force: :cascade do |t|
  t.datetime "created_at", null: false
  t.datetime "updated_at", null: false
end
```

Now we’’ll generate a migration to add our image uploader to **_pic model_**

```
rails generate migration add_image_to_pic
```

Open your **_add_image_to_pic.rb_** and add this.

```
class AddImageToPic < ActiveRecord::Migration[5.0]
    def change
        add_column :pics, :image, :string
    end
end
```

And then run `rails db:migrate` to add it to our schema.

Great, our database part is done and now we going to add CRUD functionalities to our app.

Open your **_routes.rb_** file like this

```
resources :pics
```

Let’s check our routes by doing **_rails routes_** in your terminal. And you should all the actions routes.

Create all the action methods like this in your **_pics_controller.rb_**

```
class PicsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def show
  end

  def update
  end

  def destroy
  end
end
```

> Thanks, everyone for reading it so far, hope you enjoyed it. In the next part, we will finish our application and also take it live. See you, in the next one.
