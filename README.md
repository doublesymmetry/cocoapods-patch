
# cocoapods-patch

cocoapods-patch is a Cocoapods plugin that solves the problem of forking and maintaining a separate version of a Pod when only a small (often a one-liner), long-lived change in the original Pod is needed.

The idea behind the plugin is that patches should live inside the repo (in the `patches` directory) and be distributed together with the rest of your source code. This way, you can more easily code review and test the changes to a Pod and keep it synced across your team.

## Installation

First, install the plugin

    $ gem install cocoapods-patch

Next, add a `plugin 'cocoapods-patch'` line to your Podfile to use the plugin. This will enable [automatic apply](#automatically-applying-all-patches-on-install) so you don't have to worry about it again.

That's it, you're done.

**NOTE:**
`cocoapods-patch` version 1.0.0 and above require you to use Cocoapods 1.11.0 or greater.
For anything below that please use version 0.0.5.

## Usage

### Creating a patch

To create a patch, first, you need to modify the source code of the installed Pod. Do the desired changes to the Pod source code (under the `Pods/` directory). Once you're satisfied with the result, run:

    pod patch create POD_NAME

This will create a `patches/POD_NAME.diff` file in your repository. The patch is a diff between the Pod version you have specified in your Podfile and your local changes to the Pod. You can now add and commit this patch.

### Automatically applying all patches on install

cocoapod-patch can be seamlessly integrated into the normal iOS development workflow. If you follow the installation instructions and add `plugin 'cocoapods-patch'` to your Podfile, every time you do a `pod install`, the plugin will go throught all the available patches and try to apply them. It will only warn you when the patch cannot be applied.

### Applying a patch manually

When you want to apply a patch to a pod, run

    pod patch apply POD_NAME

This command will look for the appropriate patch in the `patches` directory and, if possibly, apply it to your local Pod. A patch can be applied only once.
