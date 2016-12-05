{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_tic (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "C:\\Users\\Vilius\\AppData\\Roaming\\cabal\\bin"
libdir     = "C:\\Users\\Vilius\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.0.1\\tic-0.1.0.0-FOxgNA1UeTn1Zc2Sr49vTD"
datadir    = "C:\\Users\\Vilius\\AppData\\Roaming\\cabal\\x86_64-windows-ghc-8.0.1\\tic-0.1.0.0"
libexecdir = "C:\\Users\\Vilius\\AppData\\Roaming\\cabal\\tic-0.1.0.0-FOxgNA1UeTn1Zc2Sr49vTD"
sysconfdir = "C:\\Users\\Vilius\\AppData\\Roaming\\cabal\\etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "tic_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "tic_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "tic_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "tic_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "tic_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "\\" ++ name)
