import { PATH } from "@/constants/path";
import { MOCK_BLOGS } from "@/constants";
import type { BlogItem } from "@/types";

export type FetchBlogsParams = {
	/** 検索クエリ（例: tag:JavaScript+使い方+author:山田太郎、空白は+に変換） */
	q?: string;
	limit?: number;
	page?: number;
};

/** q パラメータをパースして tag / author / キーワードを抽出 */
export function parseQuery(q: string): {
	tag?: string;
	author?: string;
	keywords: string[];
} {
	const parts = q.split("+").filter(Boolean);
	const result: { tag?: string; author?: string; keywords: string[] } = {
		keywords: [],
	};

	for (const part of parts) {
		if (part.startsWith("tag:")) {
			result.tag = part.slice(4).trim();
		} else if (part.startsWith("author:")) {
			result.author = part.slice(7).trim();
		} else if (part.trim()) {
			result.keywords.push(part.trim());
		}
	}

	return result;
}

export type FetchBlogsResult = {
	blogs: BlogItem[];
	totalPages: number;
	currentPage: number;
};

function getMockBlogs(params: FetchBlogsParams): FetchBlogsResult {
	const { q, limit = 10, page = 1 } = params;

	let filtered = [...MOCK_BLOGS];

	if (q) {
		const { tag, author, keywords } = parseQuery(q);

		if (tag) {
			filtered = filtered.filter((b) =>
				b.tags.some((t) => t.name.toLowerCase() === tag.toLowerCase()),
			);
		}
		if (author) {
			filtered = filtered.filter(
				(b) => b.author.toLowerCase().includes(author.toLowerCase()),
			);
		}
		for (const kw of keywords) {
			const k = kw.toLowerCase();
			filtered = filtered.filter(
				(b) =>
					b.title.toLowerCase().includes(k) || b.content.toLowerCase().includes(k),
			);
		}
	}

	const safePage = Math.max(1, page);
	const start = (safePage - 1) * limit;
	const blogs = filtered.slice(start, start + limit);

	return { blogs, totalPages: Math.ceil(filtered.length / limit), currentPage: safePage };
}

async function fetchBlogsFromApi(params: FetchBlogsParams): Promise<FetchBlogsResult> {
	const { q, limit = 10, page = 1 } = params;
	const searchParams = new URLSearchParams();

	if (q) searchParams.set("q", q);
	searchParams.set("limit", String(limit));
	searchParams.set("page", String(page));

	const url = `${PATH.SEARCH}?${searchParams.toString()}`;
	const res = await fetch(url);

	if (!res.ok) {
		throw new Error(`Blog search failed: ${res.status} ${res.statusText}`);
	}

	const data = (await res.json()) as FetchBlogsResult;
	return data;
}

/**
 * ブログ検索
 * 開発環境ではモックデータを返します。
 */
export async function fetchBlogs(params: FetchBlogsParams = {}): Promise<FetchBlogsResult> {
	const isDev = typeof import.meta !== "undefined" && import.meta.env?.DEV;
	const isTest =
		(typeof import.meta !== "undefined" && import.meta.env?.MODE === "test") ||
		(typeof process !== "undefined" && process.env?.NODE_ENV === "test");

	try {
		if (isDev || isTest) {
			return getMockBlogs(params);
		}

		return await fetchBlogsFromApi(params);
	} catch (_error) {
		return getMockBlogs(params);
	}
}
