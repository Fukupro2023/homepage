import BlogListWithPagination from "./BlogListWithPagination";
import LoadingView from "./LoadingView";
import SearchForm from "./SearchForm";
import { useBlogList } from "./useBlogList";

export default function BlogContent() {
	const { inputValue, setInputValue, setPage, handleSearchSubmit, data, error, isLoading } =
		useBlogList();

	if (error) {
		return <div>Error: {error.message}</div>;
	}

	return (
		<section id="blogs">
			<SearchForm value={inputValue} onChange={setInputValue} onSubmit={handleSearchSubmit} />
			{isLoading && !data && <LoadingView />}
			{data?.status === "success" && (
				<BlogListWithPagination
					blogs={data.blogs}
					isLoading={isLoading}
					currentPage={data.currentPage}
					totalPages={data.totalPages}
					onPageChange={setPage}
				/>
			)}
			{data?.status === "failed" && <div>Error: {data.error.message}</div>}
		</section>
	);
}
