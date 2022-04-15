<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Requests;
use App\Hierarchy;


class BookHierarchyController extends Controller
{
    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */

    public function manageHierarchy()
    {
        $hierarchies = Hierarchy::where('parent_id', '=', 0)->get();

        $allHierarchies = Hierarchy::all();

        return view('hierarchy.bookHierarchyView',compact('hierarchies','allHierarchies'));
    }    
    
    
    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Http\Response
     */

    public function addHierarchy(Request $request)
    {
        $this->validate($request, [
            'title' => 'required',
        ]);

        //parent_id 0 でLv1（先頭）になる

        $input = $request->all();
        $input['parent_id'] = empty($input['parent_id']) ? 0 : $input['parent_id'];

        Hierarchy::create($input);
        return back()->with('success', '新しい相関関係が追加されました。');

    }    

}
