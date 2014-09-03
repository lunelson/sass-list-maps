//////////////////
// definitions //
//////////////////

var gulp           = require('gulp');
var sass           = require('gulp-sass');
var strip_comments = require('gulp-strip-json-comments');

//////////
// sass //
//////////

// task: sass
gulp.task('sass', function () {
    gulp.src('test/test.scss')
        .pipe(strip_comments())
        .pipe(sass({
            errLogToConsole: false,
            onError: function(err) {
                console.log(err);
            }
        }))
        .pipe(gulp.dest('test'));
});

///////////
// watch //
///////////

gulp.task('watch', function () {
    gulp.watch('test/test.scss', ['sass']);
});

gulp.task('default', ['sass', 'watch']);
