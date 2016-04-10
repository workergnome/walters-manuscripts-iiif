The Walters manuscripts as IIIF on Amazon S3.

[See the demo](#)

## What is this?

This is a set of scripts developed to download the Walter's Museum manscript collection and convert them into IIIF.  It scrapes the TEI files hosted on the Walters website and uses the PURL URIs they provide to collect the image files.

It then uses the [IIIF_S3 software library](http://www.github.com/cmoa/iiif_s3) developed by the [Carnegie Museum of Art](http://www.cmoa.org) to generate IIIF manifest files for the content as well as generate tiles and derivatives for the images themselves.  The images are served using Amazon S3 to host a IIIF server presenting a level 0 profile API, as well as a series of manifests using the IIIF Presentation API.  The top level manifest can be found at <https://workergnome-manuscripts-test.s3.amazonaws.com/collection/top.json>.

The only manual work as part of this was scraping the list of IDs for the Walters from their website.  This list appears in `data/list.txt`.

## Why am I doing this?

One of the major benefits of Open Access in the museum domain is that it allows the cultural heritage information within the community to be used for projects that would otherwise be impossible, and it allows institutions to collaborate

## How does it work?

There are two Ruby scripts that are responsible for this.  One, `scraper.rb`, 

#### Installation Instructions

Once you have cloned this repo, you will need to install the dependencies.  

You will also need [ImageMagick](#) to be installed on your system.  On OSX, the easiest way to do this is through [homebrew](#):

```bash
  brew install --with-libtiff --ignore-dependencies imagemagick
```



**Important Note**

These scripts assume that you have environment variables set for several AWS-specific values.  The easiest way to do this is to create a `.env` file within the root of this project and put the following text within it:

    AWS_ACCESS_KEY_ID=Your_Amazon_Access_Key_ID
    AWS_SECRET_ACCESS_KEY=Your_Secret
    AWS_REGION=us-east-1
    AWS_BUCKET_NAME=workergnome-manuscripts-test

*Obviously, you should replace the values with your own information.*

## Institutional Involvement

Which this project uses open data from the Walters Collection as well as the IIIF_S3 library created by the Carnegie Museum of Art, this project is not affiliated with either institution.  It's a personal exploration of the utility of these tools and concepts for use in cultural heritage.  

Thanks to the Carnegie Museum of Art for funding the development of the IIIF_S3 tool. Thanks also to the Walters Museum for providing their rich information under such a permissive license, as well as for the excellent documentation and tooling surrounding it.

Thank you in particular to Kate Blanch at the Walters for her assistance and advice on this project.  While any errors, mistakes, or problems with this project are mine alone, it would not have been possible without her assistance and expertise. 