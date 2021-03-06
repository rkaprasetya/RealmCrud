package com.raka.newslisttest.presentation.newssource

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.Navigation.findNavController
import androidx.navigation.findNavController
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.appbar.AppBarLayout
import com.raka.newslisttest.R
import com.raka.newslisttest.data.model.compact.NewsSourceCompact
import com.raka.newslisttest.utils.ViewModelFactory
import kotlinx.android.synthetic.main.fragment_news_source.*
import kotlinx.android.synthetic.main.fragment_news_source.view.*

class NewsSourcesFragment : Fragment() {
    private lateinit var viewModel: NewsSourceViewModel
    private lateinit var recyclerView: RecyclerView
    private lateinit var adapter: NewsSourceAdapter
    private lateinit var appBar:AppBarLayout
    private var page = 1
    private var isLoading = false
    private lateinit var category: String
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        category = NewsSourcesFragmentArgs.fromBundle(arguments!!).category
        viewModel = ViewModelProvider(this, ViewModelFactory()).get(NewsSourceViewModel::class.java)
    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        val view = inflater.inflate(R.layout.fragment_news_source, container, false)
        recyclerView = view.findViewById(R.id.rv_source)
        appBar = view.findViewById(R.id.ab_source)
        appBar.setOnClickListener {
            it.findNavController().popBackStack()
        }
        view.btn_source_retry.setOnClickListener {
            viewModel.getNewsSource(category,"",page.toString())
        }
        return view
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        setupAdapter()
        setupObserver()
        viewModel.getNewsSource(category,"",page.toString())
    }

    private fun setupObserver() {
        viewModel.isLoading.observe(viewLifecycleOwner, Observer {
            isLoading = it
            if (it){
                showLoadingBar()
            }else{
                hideLoadingBar()
            }
        })
        viewModel.listSource.observe(viewLifecycleOwner, Observer {
            if (!it.isNullOrEmpty()){
                setData(it)
            }else{
                showNoData()
            }
        })
        viewModel.message.observe(viewLifecycleOwner, Observer {
            it.getContentIfNotHandled()?.let {
                showToast(it)
            }
        })
    }
    private fun showNoData(){
        Log.e("here","here")
        rv_source.visibility = View.GONE
        btn_source_retry.visibility = View.VISIBLE
        hideLoadingBar()
    }
    private fun showToast(message:String){
        Toast.makeText(requireContext(),message,Toast.LENGTH_LONG).show()
    }
    private fun setData(data:List<NewsSourceCompact>){
        adapter.updateList(data as MutableList<NewsSourceCompact>)
    }
    private fun showLoadingBar(){
        pb_source.visibility = View.VISIBLE
        rv_source.visibility = View.INVISIBLE
    }
    private fun hideLoadingBar(){
        pb_source.visibility = View.GONE
        rv_source.visibility = View.VISIBLE
    }
    private fun setupAdapter(){
        adapter = NewsSourceAdapter()
        val layoutManager = LinearLayoutManager(activity)
        recyclerView.layoutManager = layoutManager
        recyclerView.addItemDecoration(DividerItemDecoration(activity,layoutManager.orientation))
        recyclerView.adapter = adapter
        setOnScrollListener(layoutManager)
    }
    private fun setOnScrollListener(layoutManager: LinearLayoutManager){
        recyclerView.addOnScrollListener(object: RecyclerView.OnScrollListener(){
            override fun onScrolled(recyclerView: RecyclerView, dx: Int, dy: Int) {
                super.onScrolled(recyclerView, dx, dy)
                val countItem = layoutManager.itemCount
                val lastVisiblePosition = layoutManager.findLastCompletelyVisibleItemPosition()
                val isLastPosition = countItem.minus(1) == lastVisiblePosition
                if (!isLoading && isLastPosition){
                    page++
                    viewModel.getNewsSource(category,"",page.toString())
                }
            }
        })
    }
}                                                                                                                                                                                                                                                                                                                                                                                