# Installation & Update

To install or update cocoapods-patch see [README](https://github.com/DoubleSymmetry/cocoapods-patch).

## Master

##### Enhancements

* None.

##### Bug Fixes

* None.

## 1.0.3 (3.3.23)

##### Enhancements

* cocoapods 1.12.0 compatibility.

##### Bug Fixes

* None.

## 1.0.2 (6.12.21)

##### Enhancements

* None.

##### Bug Fixes

* Revert to previous way of applying patches. There's a bug in Cocoapods that does not call hooks.

## 1.0.1 (2.11.21)

##### Enhancements

* Change name of generated patch files to include pod version used
  [dcvz](https://github.com/dcvz)

* Use lockfile to use more correct installation of fresh dependencies.
  [dcvz](https://github.com/dcvz)

##### Bug Fixes

* None.

## 1.0.0 (1.11.21)

##### Enhancements

* Use official pre_integrate hook
  [dcvz](https://github.com/dcvz)
  [#7](https://github.com/DoubleSymmetry/cocoapods-patch/pull/7)

##### Bug Fixes

* None.
