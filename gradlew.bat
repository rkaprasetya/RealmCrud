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
            it.btn_source_retry.visibility = View.GONE
        }
        return view
    }
    over