#' @export
get_location <- function() {
    find.package('msvs')
}

apply_dirsep <- function(x, dirsep='/') {
    return (normalizePath( x, winslash=dirsep, mustWork=FALSE))
}

get_path_from_env <- function(envvarname, dirsep='/', do_cat=TRUE) {
# LIB_PATH_UNIX=`cmd /c .\\\\src\\\\get_libpath.cmd`
    env <- Sys.getenv(envvarname)
    if (env == '') {stop(paste0('environment variable not found: ', envvarname))}
    x <- apply_dirsep( env, dirsep )
    do_cat_if(x, do_cat=do_cat)
}

do_cat_if <- function(x, do_cat=TRUE) {
    if(do_cat) {cat(x)}
    else { return(x) }
}

#' @export
get_library_path <- function(dirsep='/', do_cat=TRUE) {
# LIB_PATH_UNIX=`cmd /c .\\\\src\\\\get_libpath.cmd`
    return(get_path_from_env(envvarname = 'LIBRARY_PATH', dirsep=dirsep, do_cat=do_cat))
}

#' @export
get_include_path <- function(dirsep='/', do_cat=TRUE) {
# INCL_PATH_UNIX=`cmd /c .\\\\src\\\\get_includepath.cmd`
    return(get_path_from_env(envvarname = 'INCLUDE_PATH', dirsep=dirsep, do_cat=do_cat))
}

#' @export
get_configure_win_part <- function(dirsep='/', do_cat=TRUE) {
    x <- file.path(get_location(), 'exec', 'configure.win.part')
    do_cat_if(x, do_cat=do_cat)
}

#' @export
get_configure_win_part <- function(dirsep='/', do_cat=TRUE) {
    x <- file.path(msvs:::get_location(), 'exec', 'get_msbuildpath.cmd')
    if(!file.exists(x)) {stop('script to find msbuild was not found')}
    msbuild_exe <- system(x, intern=TRUE)
    if(!file.exists(msbuild_exe)) {stop(paste0('File does not exist: ', msbuild_exe))})
    do_cat_if(msbuild_exe, do_cat=do_cat)
}





