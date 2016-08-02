The Walters medieval manuscripts as IIIF on Amazon S3.

[See the demo (coming soon)](#)

## What is this?

This is a set of scripts developed to download the Walter's Museum manuscript collection and convert them into IIIF.  It scrapes the TEI files hosted on the Walters website and uses the PURL URIs they provide to collect the image files.

It then uses the [IIIF_S3 software library](http://www.github.com/cmoa/iiif_s3) developed by the [Carnegie Museum of Art](http://www.cmoa.org) to generate IIIF manifest files for the content as well as generate tiles and derivatives for the images themselves.  The images are served using Amazon S3 to host a IIIF server presenting a level 0 profile API, as well as a series of manifests using the IIIF Presentation API.  The top level manifest can be found at <https://workergnome-manuscripts-test.s3.amazonaws.com/collection/top.json>.

The only manual work as part of this was scraping the list of IDs for the Walters from their website.  This list appears in `data/list.txt`.

## Why am I doing this?

One of the major benefits of Open Access in the museum domain is that it allows the cultural heritage information within the community to be used for projects that would otherwise be impossible.  

This project is a demonstration of how the work of two institutions can be used to provide value to the field without the direct involvement of the institutions themselves, through the use of Open Access Data and Open Source software.   

## How does it work?

There are two Ruby scripts that are responsible for this.  One, `scraper.rb`, holds scripts for finding and downloading the information provided by the Walters.  The other, `iiif-ify`, actually downloads that information, generates the IIIF manifests, info.json files, and the image derivatives, and then uploads them to Amazon S3. 

#### Installation Instructions

Once you have cloned this repo, you will need to install the dependencies.  Assuming you have a ruby interpreter and the [Bundler](http://bundler.io) gem installed, that's as easy as

```bash
  bundle install
```

You will also need [ImageMagick](http://www.imagemagick.org/script/index.php) to be installed on your system.  On OSX, the easiest way to do this is through [homebrew](http://brew.sh):

```bash
  brew install --with-libtiff --ignore-dependencies imagemagick
```

Also, because this is currently using the unreleased [iiif_s3 gem](http://www.github.com/cmoa/iiif_s3), you should have a copy of that github repo downloaded, and should modify the path in the Gemfile to point to where it's located.  In the current system, it's:

    gem "iiif_s3", :path => "../iiif_s3"



**Important Note**

These scripts assume that you have environment variables set for several AWS-specific values.  The easiest way to do this is to create a `.env` file within the root of this project and put the following text within it:

    AWS_ACCESS_KEY_ID=Your_Amazon_Access_Key_ID
    AWS_SECRET_ACCESS_KEY=Your_Secret
    AWS_REGION=us-east-1
    AWS_BUCKET_NAME=workergnome-manuscripts-test

*Obviously, you should replace the values with your own information.*

#### Running the Script

Running the script is as simple as:

```bash
  bundle exec ruby iiif-ify.rb
```

Please note that this will take some time.  The IIIF_S3 library is not *nearly* as fast as I'd like, and the provided images are gratifyingly huge.  Also note that running this script will by default upload content to Amazon S3, which costs money.   Not much money, but it's not free.  If you'd like to run this without that constraint, in the `iiif-ify.rb` file, in the configuration object, change the `upload_to_s3: true` line to `upload_to_s3: false`.

## Institutional Involvement

This project is a personal exploration of the utility of these tools and concepts for use in cultural heritage.

Which this project uses open data from the Walters Collection as well as the IIIF_S3 library created by the Carnegie Museum of Art, this project is not affiliated with or endorsed by either institution.  However, as the lead (AKA only) developer on the IIIF_S3 project, I do reserve a certain latitude to critique the failings of that development team, of which there are many.

Thanks to the Carnegie Museum of Art for funding the development of the IIIF_S3 tool, and for releasing it under such a permissive license. 

Thanks also to the Walters Museum for providing their rich cultural data under such a permissive license as well as for the excellent documentation and tooling surrounding it.

Thank you in particular to Kate Blanch at the Walters for her assistance and advice on this project.  While any errors, mistakes, or problems with this project are mine alone, it would not have been possible without her assistance and expertise. 