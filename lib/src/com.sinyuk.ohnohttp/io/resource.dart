/**
 * A `Resource` is a source or destination of data that can be closed.
 * The close method is invoked to release resources that the object is
 * holding (such as open files).
 *
 */
abstract class Resource {
  /**
  * Closes this stream and releases any system resources associated
  * with it. If the stream is already closed then invoking this
  * method has no effect.
  */

  void dispose();
}

/**
 * This helps catch resource leaks because the compiler can detect and warn the developer 
 * when close/dispose has not been called or has been called unsafely. 
 */
void using<T extends Resource>(T resource, void Function(T) fn) {
  try {
    fn(resource);
  } finally {
    resource.dispose();
  }
}

/**
 * 
 */
void main(List<String> args) {}
