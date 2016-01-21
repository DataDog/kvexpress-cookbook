# Contributing

We love pull requests from everyone. By participating in this project, you agree to abide by the kvexpress [code of conduct](http://todogroup.org/opencodeofconduct/#kvexpress/darron@froese.org).

Fork, then clone the repo:

    git clone git@github.com:your-username/kvexpress-cookbook.git

Set up your machine:

    # Install the ChefDK.
    # Install VirtualBox.
    kitchen converge

Make sure the tests pass:

    rake
    kitchen verify

Make your change. Add tests for your change. Make the tests pass:

    rake
    kitchen verify

Push to your fork and [submit a pull request][pr].

[pr]: https://github.com/DataDog/kvexpress-cookbook/compare/

At this point you're waiting on us. We like to at least comment on pull requests within a few business days (and, typically, one or two business days). We may suggest some changes or improvements or alternatives.

Some things that will increase the chance that your pull request is accepted:

* Write tests.
* Write a [good commit message](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html).
* Communicate with us clearly so that we understand what you're trying to accomplish.
