<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- CSRF Token -->
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>管理者 - {{ config('app.name', 'Howa-Editor') }}</title>


    <!-- jQuery is only used for hide(), show() and slideDown(). All other features use vanilla JS -->
    <script
            src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous"></script>
    <!--js for CKEditor-->
    <script src="{!! asset('/js/ckeditor/ckeditor.js') !!}"></script>
    <script defer src="https://use.fontawesome.com/releases/v5.6.3/js/all.js"></script>
    <!-- Copy URL on Click
    <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/clipboard.js/1.5.5/clipboard.min.js"></script>
    <script>
        $(function () {
            var clipboard = new Clipboard('.clip_copy_btn');
        });
    </script>

    <!-- For toggling Tako Button -->
    <script type="text/javascript">
        $(function() {
            $('iframe').toggle();
            $('button').click(function(){
                $('iframe').toggle();
            });
        });
    </script>

    <!-- Fonts -->
    <link rel="dns-prefetch" href="https://fonts.gstatic.com">

    <link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet"
          integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Nunito" crossorigin="anonymous">

    <!-- Styles -->
    @if(file_exists(public_path("blogetc_admin_css.css")))
        <link href="{{ asset('blogetc_admin_css.css') }}" rel="stylesheet">
    @else
        <link href="{{ asset('css/app.css') }}" rel="stylesheet">
        {{--Edited your css/app.css file? Uncomment these lines to use plain bootstrap:--}}
        {{--<link href="https://fonts.googleapis.com/css?family=Nunito" rel="stylesheet">--}}
        {{--<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">--}}
    @endif
    <style>
        .b_frame{
            border: 1;
            width: 400px;
            height: 530px;
            display: block;
            position: fixed;
            bottom: 60px;
            right: 10px;
        }
        .button_for_chat{
            position: fixed;
            bottom: 10px;
            right: 10px;
        }
        .pagination { 
            justify-content: center;
            padding : 5px 5px 20px 5px; 
        }
        .use_icon {
	        display: inline-block;
	        font-family: FontAwesome;
	        font-style: normal;
	        font-weight: normal;
	        line-height: 1;
	        -webkit-font-smoothing: antialiased;
	        -moz-osx-font-smoothing: grayscale;
        }

    </style>

</head>
<body>
<div id="app">
    <main class="py-4">

        <div class='container'>
            <div class='row'>
                
                    @if (isset($errors) && count($errors))
                        <div class="alert alert-danger">
                            <b>エラーが発生しました。</b>
                            <ul class='m-0'>
                                @foreach($errors->all() as $error)
                                    <li>{{ $error }}</li>
                                @endforeach
                            </ul>
                        </div>
                    @endif

                    {{--REPLACING THIS FILE WITH YOUR OWN LAYOUT FILE? Don't forget to include the following section!--}}

                    @if(\WebDevEtc\BlogEtc\Helpers::has_flashed_message())
                        <div class='alert alert-info'>
                            <h3>{{\WebDevEtc\BlogEtc\Helpers::pull_flashed_message() }}</h3>
                        </div>
                    @endif
                    @yield('content')
            </div>
        </div>
        </main>
</div>

@if( config("blogetc.use_wysiwyg") && config("blogetc.echo_html") && (in_array( \Request::route()->getName() ,[ 'blogetc.admin.create_post' , 'blogetc.admin.edit_post'  ])))
    <script type="text/javascript">
        CKEDITOR.replace('post_body',{
            language: 'ja',
            imageUploadUrl: "{{route('uploadwithdd', ['_token' => csrf_token() ])}}",
            filebrowserUploadUrl: "{{route('upload', ['_token' => csrf_token() ])}}",
            filebrowserUploadMethod: 'form',
            filebrowserBrowseUrl: '{{ route('browsevideo') }}',
            filebrowserImageBrowseUrl: '{{ route('blogetc.admin.images.all') }}',
        });
    </script>
@endif
<script type="text/javascript">
    document.addEventListener("copy", function (e) {
        /*if (!window.opener || window.opener.closed){
            console.log('No opener');
        }else{
            var copied = window.getSelection().toString();
            console.log(window.opener.document.getElementsByClassName("cke_dialog_ui_input_text")[1])
            window.opener.document.getElementsByClassName("cke_dialog_ui_input_text")[1].value += copied;
            if (document.getElementById("video_browse") != null){
                //console.log('video');
                window.opener.document.getElementById("cke_198_textInput").value = copied;
            }else{
                //console.log('image');
                window.opener.document.getElementById("cke_82_textInput").value = copied;
            }
        }*/
        window.close();
    });
</script>

</body>
</html>
