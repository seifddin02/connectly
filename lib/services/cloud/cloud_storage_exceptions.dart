class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreatePostException extends CloudStorageException {}

class CouldNotGetAllPostsException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotDeletePostException extends CloudStorageException {}

class CouldNotGetUserDetailsException extends CloudStorageException {}
